% audio type, sampling rate, window shift, window type, window length
function short_time_analysis(audio, fs, R, win, L)   
   % wave form plot
    N = length(audio);
    t = (0:N-1)/fs;
    figure
    plot(t, audio), title('full time waveform');
    xlabel('time (s)'), ylabel('magnitude');
    
    % short time energy, magnitude, zero-crossing
    iter_num = ceil(N/R);   % 共188帧
    frame = zeros(iter_num,L);   
    frame_energy = zeros(iter_num,1);
    shift = 0;   % 记录窗移
    zero_crossing_count = zeros(iter_num,1);   % 记录zero-crossing
    count = 0;
    for i=1:iter_num
        if shift*R+1+L<N
            frame(i,:) = audio(shift*R+1 : shift*R+L) .* win;   % 截取一个frame中的语音信号
%             frame_energy(i) = conv(frame(i).^2, win.^2);
            frame_energy(i) = sum(frame(i).^2);
            frame_magnitude(i) = sum(abs(frame(i)));
            
            % zero-crossing
            for k=1:length(frame(i,:))-1
                if frame(i,k) * frame(i,k+1)<0
                    count = count+1;
                end
            end
            zero_crossing_count(i) = count;
            count = 0;
            shift = shift + 1;
            
        % 处理最后一个frame    
        else
            lastframe = audio(shift*R+1 : N);
            zero_padding_length = L - length(lastframe);
            frame(i,:) = [lastframe',  zeros(1,zero_padding_length)] .* win';   % 补零
%             frame_energy(i) = conv(frame(i).^2, win);
            frame_energy(i) = sum(frame(i).^2);
            frame_magnitude(i) = sum(abs(frame(i)));
            
            % zero-crossing
            for k=1:length(frame(i,:))-1
                if frame(i,k) * frame(i,k+1)<0
                    count = count+1;
                end
            end
            zero_crossing_count(i) = count;
            count = 0;
        end
    end
%     frame_energy = sum(frame.^2);
    time_axis = (0:iter_num-1) * (R/fs);
    figure
    plot(time_axis, frame_energy), xlabel('time(s)'), ylabel('energy');
    title('short time energy');
    
    % short time magnitude
    figure
    plot(time_axis, frame_magnitude), xlabel('time(s)'), ylabel('magnitude');
%     ylim([0,1])
    title('short time magnitude');
    
    % short time zero-crossing
    figure
    plot(time_axis, zero_crossing_count), xlabel('time(s)'), ylabel('number');
    title('zero crossing count')
end